package cmd

import (
	"fmt"
	"log"
	"runtime/debug"

	"github.com/spf13/cobra"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "root",
	Short: "Command line tools for vi backend",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Please pass any subcommands")
	},
}

func init() {
	rootCmd.AddCommand(slackNotificationCmd)
}

// Execute executes the root command.
func Execute() {
	defer func() {
		if err := recover(); err != nil {
			fmt.Printf("[PANIC] %s\n\n%s\n", err, string(debug.Stack()))
		}
	}()

	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err.Error())
	}
}
