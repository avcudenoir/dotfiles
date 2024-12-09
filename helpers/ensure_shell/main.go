package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"os/user"
	"strings"
	"syscall"
)

func changeUserShell(username, newShell string) error {
	// Get user information
	_, err := user.Lookup(username)
	if err != nil {
		return fmt.Errorf("error looking up user (doesn't exist?) %s: %v", username, err)
	}

	// Call chsh using syscall
	err = syscall.Exec("/usr/bin/chsh", []string{"chsh", "-s", newShell, username}, os.Environ())
	if err != nil {
		return fmt.Errorf("error changing shell: %v", err)
	}
	return nil
}

func checkAndAddShell(shellPath string) error {
	// First, check if the shell exists in the file
	file, err := os.Open("/etc/shells")
	if err != nil {
		return fmt.Errorf("error opening /etc/shells: %v", err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	exists := false

	for scanner.Scan() {
		if strings.TrimSpace(scanner.Text()) == shellPath {
			exists = true
			break
		}
	}

	if err := scanner.Err(); err != nil {
		return fmt.Errorf("error reading file: %v", err)
	}

	// If shell doesn't exist, append it
	if !exists {
		// Open file in append mode
		appendFile, err := os.OpenFile("/etc/shells", os.O_APPEND|os.O_WRONLY, 0644)
		if err != nil {
			return fmt.Errorf("error opening file for append: %v", err)
		}
		defer appendFile.Close()

		// Add newline and shell path
		if _, err := appendFile.WriteString("\n" + shellPath + "\n"); err != nil {
			return fmt.Errorf("error appending to file: %v", err)
		}

		fmt.Printf("Added %s to /etc/shells\n", shellPath)
	} else {
		fmt.Printf("%s already exists in /etc/shells\n", shellPath)
	}

	return nil
}

func main() {

	shellPath := flag.String("shellpath", "", "path to shell binary")
	targetUser := flag.String("user", "", "unix username")

	if os.Geteuid() != 0 {
		fmt.Println("This program must be run as root (sudo)")
		os.Exit(1)
	}

	flag.Parse()

	if err := checkAndAddShell(*shellPath); err != nil {
		fmt.Fprintf(os.Stderr, "Error updating /etc/shells: %v\n", err)
		os.Exit(1)
	}

	if err := changeUserShell(*targetUser, *shellPath); err != nil {
		fmt.Fprintf(os.Stderr, "Error chaning user's shell: %v\n", err)
		os.Exit(1)
	}
}
