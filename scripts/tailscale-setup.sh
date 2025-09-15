#!/bin/bash

# Tailscale setup and management script
# This script helps with common Tailscale operations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Helper functions
print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
}

print_error() {
    echo -e "${RED}✗ $1${RESET}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${RESET}"
}

# Check if Tailscale is installed
if ! command -v tailscale &> /dev/null; then
    print_error "Tailscale is not installed. Run 'brew install tailscale' first."
    exit 1
fi

# Function to check Tailscale status
check_status() {
    if sudo tailscale status &> /dev/null; then
        print_success "Tailscale is running"
        echo ""
        sudo tailscale status
    else
        print_error "Tailscale is not running or not authenticated"
        print_info "Run: sudo tailscale up"
    fi
}

# Function to start Tailscale
start_tailscale() {
    print_info "Starting Tailscale service..."
    brew services start tailscale
    sleep 2
    
    if brew services list | grep -q "tailscale.*started"; then
        print_success "Tailscale service started"
        print_info "Now run: sudo tailscale up"
    else
        print_error "Failed to start Tailscale service"
    fi
}

# Function to stop Tailscale
stop_tailscale() {
    print_info "Stopping Tailscale..."
    sudo tailscale down
    brew services stop tailscale
    print_success "Tailscale stopped"
}

# Function to authenticate
authenticate() {
    print_info "Authenticating with Tailscale..."
    sudo tailscale up
}

# Function to show IP addresses
show_ips() {
    if sudo tailscale status &> /dev/null; then
        print_info "Your Tailscale IP:"
        sudo tailscale ip -4
        echo ""
        print_info "Your Tailscale IPv6:"
        sudo tailscale ip -6
    else
        print_error "Tailscale is not running"
    fi
}

# Main menu
case "${1:-}" in
    status)
        check_status
        ;;
    start)
        start_tailscale
        ;;
    stop)
        stop_tailscale
        ;;
    up|auth)
        authenticate
        ;;
    ip)
        show_ips
        ;;
    *)
        echo "Tailscale Setup Helper"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  status    Check Tailscale status"
        echo "  start     Start Tailscale service"
        echo "  stop      Stop Tailscale service"
        echo "  up/auth   Authenticate with Tailscale"
        echo "  ip        Show your Tailscale IP addresses"
        echo ""
        echo "Common workflow:"
        echo "  1. $0 start      # Start the service"
        echo "  2. $0 up         # Authenticate"
        echo "  3. $0 status     # Check connection"
        ;;
esac