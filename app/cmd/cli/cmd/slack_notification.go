package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var slackNotificationCmd = &cobra.Command{
	Use:   "slack-notification",
	Short: "Send a message to slack",
	Args:  cobra.RangeArgs(2, 2),
	Run: func(cmd *cobra.Command, args []string) {
		// TODO(istsh): send to slack

		trigger := args[0]
		envName := args[1]

		fmt.Printf("successfully sent to slack. trigger: %s, env: %s\n", trigger, envName)
	},
}
