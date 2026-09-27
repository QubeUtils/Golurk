#!/usr/bin/env bats

setup() {
  export TEST_DIR="$(mktemp -d)"
  # Copy golurk from the real project root to the test dir
  cp "${BATS_TEST_DIRNAME}/../golurk" "$TEST_DIR/"
  cd "$TEST_DIR"
  
  # Setup diverse test environment
  mkdir -p src/auth-service src/payment-service target logs
  
  # Text files
  echo "auth logic" > src/auth-service/main.py
  echo "payment logic" > src/payment-service/main.go
  echo "config" > src/payment-service/config.yaml
  echo "console.log('hello');" > app.js
  
  # Binary / ignored files
  dd if=/dev/urandom of=target/app.bin bs=1K count=100 2>/dev/null
  echo "test log" > logs/app.log
  
  # Large text file
  awk 'BEGIN{for(i=0;i<50000;i++) print "large data"}' > large.txt
  
  # Gitignore setup
  cat << 'EOF' > .gitignore
target/
logs/
*.bin
# Negation
!logs/important.log
EOF
  echo "important" > logs/important.log
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "Tree excludes gitignored items including standard patterns" {
  run ./golurk tree
  [ "$status" -eq 0 ]
  [[ "$output" != *"target"* ]]
  [[ "$output" != *"app.bin"* ]]
  [[ "$output" == *"src"* ]]
  [[ "$output" == *"app.js"* ]]
}

@test "Tree respects gitignore negation (!)" {
  run ./golurk tree
  [ "$status" -eq 0 ]
  [[ "$output" == *"important.log"* ]]
}

@test "Microservices detection finds src directory" {
  run ./golurk micro --microservices
  [ "$status" -eq 0 ]
  [[ "$output" == *"src"* ]]
}

@test "Microservices selection filters output to selected services" {
  run ./golurk tree -m "auth"
  [ "$status" -eq 0 ]
  [[ "$output" == *"auth-service"* ]]
  [[ "$output" != *"payment-service"* ]]
  [[ "$output" != *"app.js"* ]]
}

@test "Contents dump (-C) generates markdown blocks safely" {
  run ./golurk tree -C dump.md
  [ "$status" -eq 0 ]
  [ -f "dump.md" ]
  run cat dump.md
  [[ "$output" == *"\`\`\`py"* ]]
  [[ "$output" == *"auth logic"* ]]
  [[ "$output" != *"app.bin"* ]]
}

@test "Skip binaries (-B) correctly ignores binary files in contents dump" {
  run ./golurk tree -C dump.md -B
  [ "$status" -eq 0 ]
  run cat dump.md
  [[ "$output" == *"[Skipped binary file]"* ]]
}

@test "Max size (-M) correctly ignores large files" {
  run ./golurk tree -C dump.md -M 100k
  [ "$status" -eq 0 ]
  run cat dump.md
  [[ "$output" != *"large data"* ]]
}

@test "Include extensions (--include-ext) filters correctly" {
  run ./golurk tree -C dump.md --include-ext py,yaml
  [ "$status" -eq 0 ]
  run cat dump.md
  [[ "$output" == *"auth logic"* ]]
  [[ "$output" == *"config"* ]]
  [[ "$output" != *"payment logic"* ]] # .go file
  [[ "$output" != *"console.log"* ]]   # .js file
}

@test "Directory pattern (-d) filters out non-matching directories" {
  run ./golurk tree -C dump.md -d auth
  [ "$status" -eq 0 ]
  run cat dump.md
  [[ "$output" == *"auth logic"* ]]
  [[ "$output" != *"payment logic"* ]]
}

@test "JSON export generates valid JSON structure" {
  run ./golurk tree --json
  [ "$status" -eq 0 ]
  [[ "$output" == *"{"* ]]
  [[ "$output" == *"\"version\":"* ]]
  [[ "$output" == *"\"items\": ["* ]]
  [[ "$output" == *"\"type\": \"directory\""* ]]
  [[ "$output" == *"\"path\": "* ]]
}

@test "YAML export generates valid YAML structure" {
  run ./golurk tree --yaml
  [ "$status" -eq 0 ]
  [[ "$output" == *"version:"* ]]
  [[ "$output" == *"items:"* ]]
  [[ "$output" == *"- path:"* ]]
}

@test "Stats output includes counts and token estimation" {
  run ./golurk stats
  [ "$status" -eq 0 ]
  [[ "$output" == *"Directories:"* ]]
  [[ "$output" == *"Files:"* ]]
  [[ "$output" == *"Total Size:"* ]]
  [[ "$output" == *"LLM Tokens"* ]]
}

@test "Project config (.golurkrc) overrides defaults" {
  echo "MAX_DEPTH=1" > .golurkrc
  run ./golurk tree
  [ "$status" -eq 0 ]
  [[ "$output" != *"main.py"* ]] # Inside src/auth-service (depth 2)
  [[ "$output" == *"app.js"* ]]  # Depth 1
}

@test "File name pattern (-f) restricts output" {
  run ./golurk tree -f "main.*"
  [ "$status" -eq 0 ]
  [[ "$output" == *"main.py"* ]]
  [[ "$output" == *"main.go"* ]]
  [[ "$output" != *"config.yaml"* ]]
}
