//go:build tools
// Keep go.mod dependencies on dependabot "go mod tidy" (https://github.com/golang/go/issues/25922)

package main

import (
    _ "github.com/XavierBrassoud/hugo-theme-vertica-resume"
)
