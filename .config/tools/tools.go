//go:build tools

// This file will never be built, but `go mod tidy` will see the packages
// imported here as dependencies and not remove them from `go.mod`.
// https://github.com/golang/go/issues/25922

package main

import (
	_ "github.com/XavierBrassoud/hugo-theme-vertica-resume"
)
