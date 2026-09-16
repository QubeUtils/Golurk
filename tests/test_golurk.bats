#!/usr/bin/env bats

setup() {
  # Create a temporary workspace for each test
  export TEST_DIR="$(mktemp -d)"
  cp ./golurk "$TEST_DIR/"
  cd "$TEST_DIR"
  
  # Create some dummy files
  mkdir -p src target
  touch src/main.java target/binary.bin .gitignore
  echo "target/" > .gitignore
}

teardown() {
  # Cleanup
  rm -rf "$TEST_DIR"
}

@test "golurk tree hides gitignored directories by default" {
  run ./golurk tree
  [ "$status" -eq 0 ]
  [[ "$output" != *"target"* ]]
  [[ "$output" == *"src"* ]]
}

@test "golurk micro detects src directory" {
  run ./golurk micro --microservices
  [ "$status" -eq 0 ]
  [[ "$output" == *"src"* ]]
}

@test "golurk tree -C generates content dump safely" {
  echo "hello" > src/main.java
  run ./golurk tree -C dump.txt
  [ "$status" -eq 0 ]
  [ -f "dump.txt" ]
  run cat dump.txt
  [[ "$output" == *"main.java"* ]]
}
