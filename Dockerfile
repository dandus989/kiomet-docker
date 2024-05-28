## START ##

###
# PURPOSE 
#
#   Build a docker image for kiomet
#
# ACKNOWLEDGEMENT
#
#   Acknowledge SoftbearStudios
#   kiomet is a trademark of Softbear, Inc.
#   (https://github.com/SoftbearStudios/kiomet)
#   Licensed under the GNU Affero General Public License v3.0
#
# LICENCE
#
#   This file is part of https://github.com/dandus989/kiomet
#   Copyright (C) 2024 https://github.com/dandus989
#
#   This library is free software; you can redistribute it and/or
#   modify it under the terms of the GNU Lesser General Public
#   License as published by the Free Software Foundation; either
#   version 3 of the License, or (at your option) any later version.
#
#   This library is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public
#   License along with this library; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
#   You can also find the full text of the license at <https://www.gnu.org/licenses/lgpl-3.0.html>
###

###
# Stage #1 : build the kiomet server and WASM client
###

# Use a Rust base image with Cargo installed
# (note: need the full Debian Rust image to build successfully)
FROM rust:bookworm AS builder

# Set the working directory inside the container
WORKDIR /usr/src

# Below 1.- 3. are based on Build Instructions in the official 
# kiomet github repository (https://github.com/SoftbearStudios/kiomet)
# as of 26 May 2024

# 1. Install Rust Nightly and the WebAssembly target
RUN rustup install nightly-2023-04-25 \
    && rustup default nightly-2023-04-25 \
    && rustup target add wasm32-unknown-unknown \
#
# 2. Install trunk
    && cargo install --locked trunk --version 0.15.0 \
#
# 3. Get and build kiomet client and server
    && git clone https://github.com/SoftbearStudios/kiomet \
    && cd kiomet/client \
    && trunk build --release \
    && cd ../server \
    && cargo build --release

##
# Stage #2 : create the slim down image with the build
#            in Stage #1 above
##

FROM debian:bookworm-slim

# copy the server build
WORKDIR /usr/local/bin/kiomet/server
COPY --from=builder /usr/src/kiomet/server/target/release .

# copy the WASM client 
WORKDIR /usr/local/bin/kiomet/client
COPY --from=builder /usr/src//kiomet/client/dist .

# create the log location
WORKDIR /var/log/kiomet

# Exposure port 80 (http) and 443 (https)
EXPOSE 80
EXPOSE 443

# run kiomet server
ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/kiomet/server/server >> /var/log/kiomet/log.log 2>&1"]

## End ##
