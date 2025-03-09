Dell R720xd Server Silent Fan Control Script

The Dell R720xd is a powerful and cost-effective 2U server. However, when used in a home environment, its default fan speeds can generate significant noise, which may be disruptive.

While the stock fan performance is ideal for high-load scenarios, most home users do not require maximum cooling capacity. This script allows you to reduce fan noise while maintaining efficient cooling based on real-time system temperatures.

Installation

Install ipmitool on your server to enable temperature monitoring and fan speed adjustments.

Copy the dell-r720-fan-control_local.sh script to a directory on your server (e.g., /root).
Make the script executable.

Add it to a cron job to run once per minute.
Configuration

The script checks the server's temperature every 10 seconds and dynamically adjusts fan speeds accordingly.

If the default fan speed does not meet your requirements, you can fine-tune it by modifying the CORRECTION variable (adjusting it positively or negatively will increase or decrease the overall fan speed).

You can also modify the ITERATION_SLEEP and ITERATION_MAX variables to control the frequency of temperature checks.
Support & Contributions

If you find this script useful, consider supporting its development by making a donation. Your contributions help keep this project alive—perhaps even buy a pizza!