package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

type ComponentType string

const (
	Tap  ComponentType = "tap"
	Cask ComponentType = "cask"
	Pkg  ComponentType = "pkg"
)

func main() {
	install(Tap)
	install(Cask)
	install(Pkg)
	log.Println("=== Brew installer has finished! ===")
}

func install(componentType ComponentType) {
	source_dir, exists := os.LookupEnv("CHEZMOI_SOURCE_DIR")
	if !exists {
		log.Fatalf("CHEZMOI_SOURCE_DIR not set")
	}

	path := filepath.Join(source_dir, "brew", fmt.Sprintf("%s.txt", componentType))
	log.Printf("=== Starting installation of brew component: %s", componentType)

	content, err := os.ReadFile(path)
	if err != nil {
		log.Fatalf("Error reading file: %v", err)
	}

	items := strings.Split(strings.TrimSpace(string(content)), "\n")
	runBrew(items, componentType)

	log.Printf("=== Finished installation of brew component: %s", componentType)
}

func runBrew(items []string, componentType ComponentType) {
	if len(items) == 0 {
		log.Println("Nothing to do")
		return
	}

	args := brewArgs(componentType)
	switch componentType {
	case Tap:
		for _, item := range items {
			systemCmd("brew", append(args, item))
		}
	default:
		systemCmd("brew", append(args, items...))
	}
}

func systemCmd(cmd string, args []string) {
	command := exec.Command(cmd, args...)
	command.Stderr = os.Stdout
	command.Stdout = os.Stdout
	command.Env = append(os.Environ(), "TERM=xterm-256color")

	if err := command.Run(); err != nil {
		log.Fatalf("Issue encountered: %v", err)
	} else {
		log.Printf("`%s %s` returned successfully", cmd, strings.Join(args, " "))
	}
}

func brewArgs(componentType ComponentType) []string {
	switch componentType {
	case Pkg:
		return []string{"install", "-q"}
	case Cask:
		return []string{"install", "--cask", "-q", "--adopt"}
	case Tap:
		return []string{"tap"}
	default:
		log.Fatalf("Unknown component provided: %s", componentType)
		return nil
	}
}
