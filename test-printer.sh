#!/bin/bash

#* Copyright (C) 2026
#*
#* This program is free software; you can redistribute it and/or modify
#* it under the terms of the GNU General Public License as published by
#* the Free Software Foundation; either version 2 of the License, or
#* (at your option) any later version.
#*
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#* GNU General Public License for more details.
#*
#* You should have received a copy of the GNU General Public License
#* along with this program; if not, write to the Free Software
#* Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

VERSION='1.0'

# Script to test installed printer configuration for foo2zjs driver
# This helps verify that the printer is properly installed and configured

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage function
usage() {
    cat <<EOF
Usage: $(basename $0) [options] [printer-name]

Test installed printer configuration for foo2zjs driver suite.

Options:
    -h, --help          Show this help message
    -l, --list          List all installed printers
    -s, --status        Check printer status
    -t, --test-page     Send a test page to the printer
    -c, --check-deps    Check if required dependencies are installed
    -a, --all           Run all tests
    -v, --verbose       Verbose output

If no printer name is specified, the default printer will be used.

Examples:
    $(basename $0) -l                    # List all printers
    $(basename $0) -s HP_LaserJet_1020   # Check status of specific printer
    $(basename $0) -t                    # Send test page to default printer
    $(basename $0) -a HP_LaserJet_1020   # Run all tests on specific printer

EOF
    exit 0
}

# Error handling function
error() {
    echo -e "${RED}ERROR:${NC} $1" >&2
    exit 1
}

# Warning function
warning() {
    echo -e "${YELLOW}WARNING:${NC} $1" >&2
}

# Success function
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Info function
info() {
    echo -e "${BLUE}INFO:${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
    info "Checking required dependencies..."
    
    local deps_ok=true
    
    # Check for lpstat (CUPS)
    if command_exists lpstat; then
        success "lpstat found (CUPS is installed)"
    else
        warning "lpstat not found - CUPS may not be installed"
        deps_ok=false
    fi
    
    # Check for lpr
    if command_exists lpr; then
        success "lpr found"
    else
        warning "lpr not found - cannot print test pages"
        deps_ok=false
    fi
    
    # Check for gs (Ghostscript)
    if command_exists gs; then
        success "Ghostscript found ($(gs --version))"
    else
        warning "Ghostscript not found - required for printing"
        deps_ok=false
    fi
    
    # Check for usb_printerid if installed
    if [ -x /usr/bin/usb_printerid ]; then
        success "usb_printerid found"
    elif [ -x ./usb_printerid ]; then
        success "usb_printerid found in current directory"
    else
        info "usb_printerid not found (optional for USB printer detection)"
    fi
    
    if [ "$deps_ok" = true ]; then
        echo ""
        success "All required dependencies are installed"
        return 0
    else
        echo ""
        warning "Some dependencies are missing"
        return 1
    fi
}

# List all printers
list_printers() {
    info "Listing all installed printers..."
    
    if ! command_exists lpstat; then
        error "lpstat command not found. Is CUPS installed?"
    fi
    
    echo ""
    lpstat -p -d 2>/dev/null
    
    if [ $? -ne 0 ]; then
        warning "No printers found or CUPS is not running"
        return 1
    fi
    
    echo ""
    info "To get detailed information about a printer, use: lpstat -l -p <printer-name>"
    return 0
}

# Check printer status
check_printer_status() {
    local printer_name="$1"
    
    if [ -z "$printer_name" ]; then
        # Get default printer
        printer_name=$(lpstat -d 2>/dev/null | grep -oP '(?<=system default destination: ).*')
        if [ -z "$printer_name" ]; then
            error "No printer specified and no default printer configured"
        fi
        info "Using default printer: $printer_name"
    fi
    
    info "Checking status of printer: $printer_name"
    echo ""
    
    # Check if printer exists
    if ! lpstat -p "$printer_name" >/dev/null 2>&1; then
        error "Printer '$printer_name' not found. Use -l to list available printers."
    fi
    
    # Get printer status
    lpstat -p "$printer_name"
    
    # Get printer jobs
    echo ""
    info "Current print jobs:"
    lpstat -o "$printer_name" 2>/dev/null || echo "No print jobs in queue"
    
    # Check if it's a foo2zjs printer
    echo ""
    info "Checking printer driver..."
    local ppd_file=$(lpstat -v "$printer_name" 2>/dev/null)
    echo "$ppd_file"
    
    # Try to get more info about the driver
    if command_exists lpinfo; then
        local driver_info=$(lpoptions -p "$printer_name" 2>/dev/null | grep -o 'printer-make-and-model=[^,]*')
        if [ -n "$driver_info" ]; then
            echo ""
            info "Driver info: $driver_info"
            
            if echo "$driver_info" | grep -qi "foo2"; then
                success "This appears to be a foo2zjs family printer"
            else
                warning "This may not be a foo2zjs printer"
            fi
        fi
    fi
    
    return 0
}

# Send test page
send_test_page() {
    local printer_name="$1"
    
    if [ -z "$printer_name" ]; then
        # Get default printer
        printer_name=$(lpstat -d 2>/dev/null | grep -oP '(?<=system default destination: ).*')
        if [ -z "$printer_name" ]; then
            error "No printer specified and no default printer configured"
        fi
        info "Using default printer: $printer_name"
    fi
    
    # Check if printer exists
    if ! lpstat -p "$printer_name" >/dev/null 2>&1; then
        error "Printer '$printer_name' not found. Use -l to list available printers."
    fi
    
    info "Preparing to send test page to: $printer_name"
    
    # Look for testpage.ps
    local testpage=""
    if [ -f "./testpage.ps" ]; then
        testpage="./testpage.ps"
    elif [ -f "/usr/share/foo2zjs/testpage.ps" ]; then
        testpage="/usr/share/foo2zjs/testpage.ps"
    else
        # Create a simple test page
        warning "testpage.ps not found, creating a simple test page"
        testpage="/tmp/foo2zjs-testpage-$$.ps"
        cat > "$testpage" <<'TESTPAGE'
%!PS-Adobe-3.0
%%Title: foo2zjs Test Page
%%Creator: test-printer.sh
%%Pages: 1
%%EndComments
%%Page: 1 1
/Helvetica findfont 24 scalefont setfont
72 720 moveto
(foo2zjs Driver Test Page) show
/Helvetica findfont 14 scalefont setfont
72 680 moveto
(If you can read this, your printer is working correctly.) show
72 650 moveto
(Date: ) show
currenttime pop 24 60 60 mul mul div cvi =string cvs show
showpage
%%EOF
TESTPAGE
    fi
    
    echo ""
    info "Sending test page from: $testpage"
    
    if lpr -P "$printer_name" "$testpage" 2>/dev/null; then
        success "Test page sent successfully"
        echo ""
        info "Check printer status with: $(basename $0) -s $printer_name"
    else
        error "Failed to send test page"
    fi
    
    # Clean up temporary test page
    if [ -f "/tmp/foo2zjs-testpage-$$.ps" ]; then
        rm -f "/tmp/foo2zjs-testpage-$$.ps"
    fi
    
    return 0
}

# Main script
main() {
    local do_list=false
    local do_status=false
    local do_test=false
    local do_check=false
    local do_all=false
    local printer_name=""
    local verbose=false
    
    # Parse command line arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -l|--list)
                do_list=true
                shift
                ;;
            -s|--status)
                do_status=true
                shift
                ;;
            -t|--test-page)
                do_test=true
                shift
                ;;
            -c|--check-deps)
                do_check=true
                shift
                ;;
            -a|--all)
                do_all=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                printer_name="$1"
                shift
                ;;
        esac
    done
    
    # If no options specified, show usage
    if [ "$do_list" = false ] && [ "$do_status" = false ] && \
       [ "$do_test" = false ] && [ "$do_check" = false ] && \
       [ "$do_all" = false ]; then
        usage
    fi
    
    # Run all tests if -a is specified
    if [ "$do_all" = true ]; then
        do_check=true
        do_list=true
        do_status=true
    fi
    
    # Execute requested operations
    local exit_code=0
    
    if [ "$do_check" = true ]; then
        check_dependencies
        echo ""
    fi
    
    if [ "$do_list" = true ]; then
        list_printers
        echo ""
    fi
    
    if [ "$do_status" = true ]; then
        check_printer_status "$printer_name" || exit_code=$?
        echo ""
    fi
    
    if [ "$do_test" = true ]; then
        send_test_page "$printer_name" || exit_code=$?
    fi
    
    exit $exit_code
}

# Run main function
main "$@"
