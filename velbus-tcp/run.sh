#!/usr/bin/with-contenv bashio

# Read options from the HA add-on configuration tab
SERIAL_AUTODISCOVER=$(bashio::config 'serial_autodiscover')
SERIAL_PORT=$(bashio::config 'serial_port')
TCP_PORT=$(bashio::config 'tcp_port')
TCP_AUTH=$(bashio::config 'tcp_auth')
TCP_AUTH_KEY=$(bashio::config 'tcp_auth_key')
VELBUSLINK_PORT=$(bashio::config 'velbuslink_port')
VELBUSLINK_AUTH=$(bashio::config 'velbuslink_auth')
VELBUSLINK_AUTH_KEY=$(bashio::config 'velbuslink_auth_key')
VELBUSLINK_SSL=$(bashio::config 'velbuslink_ssl')

bashio::log.info "Starting Velbus TCP Bridge..."
bashio::log.info "Serial autodiscover: ${SERIAL_AUTODISCOVER}"
bashio::log.info "TCP port (HA): ${TCP_PORT}"
bashio::log.info "TCP port (VelbusLink): ${VELBUSLINK_PORT}"

# Build the settings.json that python-velbustcp expects
cat > /tmp/settings.json <<EOF
{
    "ntp": {
        "enabled": false
    },
    "connections": [
        {
            "host": "0.0.0.0",
            "port": ${TCP_PORT},
            "relay": true,
            "ssl": false,
            "cert": "",
            "pk": "",
            "auth": ${TCP_AUTH},
            "auth_key": "${TCP_AUTH_KEY}"
        },
        {
            "host": "0.0.0.0",
            "port": ${VELBUSLINK_PORT},
            "relay": true,
            "ssl": ${VELBUSLINK_SSL},
            "cert": "",
            "pk": "",
            "auth": ${VELBUSLINK_AUTH},
            "auth_key": "${VELBUSLINK_AUTH_KEY}"
        }
    ],
    "serial": {
        "autodiscover": ${SERIAL_AUTODISCOVER},
        "port": "${SERIAL_PORT}"
    },
    "logging": {
        "type": "info",
        "output": "stream"
    }
}
EOF

bashio::log.info "Launching bridge..."
exec velbustcp --settings /tmp/settings.json
