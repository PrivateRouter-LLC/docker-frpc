#!/bin/ash

# Check if we have a valid IP and TOKEN set
[[ -z "${FRPC_IP}" || -z "${FRPC_TOKEN}" ]] && {
    echo "FRPC_IP and FRPC_TOKEN must be set.";
    exit 1;
}

# Check if any services are set and then iterate through them for the config
if [ ! -z "${FRPC_SERVICES}" ]; then
    set -- $(echo "${FRPC_SERVICES}")
    for service in "$@"; do
        SERVICE_NAME=`echo $service | cut -d',' -f1`
        SERVICE_PROTOCOL=`echo $service | cut -d',' -f2`
        SERVICE_PORT_LOCAL=`echo $service | cut -d',' -f3`
        SERVICE_PORT_REMOTE=`echo $service | cut -d',' -f4`
        SERVICE_IP_LOCAL=`echo $service | cut -d',' -f5`
        # Default with service,protocol,local_port
        if [ ! -z $SERVICE_NAME ] && [ ! -z $SERVICE_PROTOCOL ] && [ ! -z $SERVICE_PORT_LOCAL ] && [ -z $SERVICE_PORT_REMOTE ] && [ -z $SERVICE_IP_LOCAL ]; then
            EXTRA_FRPC=$(printf "${EXTRA_FRPC}\n[${SERVICE_NAME}]\ntype = ${SERVICE_PROTOCOL}\nlocal_ip = 127.0.0.1\nlocal_port = ${SERVICE_PORT_LOCAL}\nremote_port= ${SERVICE_PORT_LOCAL}\n ")
        # Next service,protocol,local_port,remote_port
        elif [ ! -z $SERVICE_NAME ] && [ ! -z $SERVICE_PROTOCOL ] && [ ! -z $SERVICE_PORT_LOCAL ] && [ ! -z $SERVICE_PORT_REMOTE ] && [ -z $SERVICE_IP_LOCAL ]; then
            EXTRA_FRPC=$(printf "${EXTRA_FRPC}\n[${SERVICE_NAME}]\ntype = ${SERVICE_PROTOCOL}\nlocal_ip = 127.0.0.1\nlocal_port = ${SERVICE_PORT_LOCAL}\nremote_port= ${SERVICE_PORT_REMOTE}\n ")
        # Next service,protocol,local_port,remote_port,local_ip
        elif [ ! -z $SERVICE_NAME ] && [ ! -z $SERVICE_PROTOCOL ] && [ ! -z $SERVICE_PORT_LOCAL ] && [ ! -z $SERVICE_PORT_REMOTE ] && [ ! -z $SERVICE_IP_LOCAL ]; then
            EXTRA_FRPC=$(printf "${EXTRA_FRPC}\n[${SERVICE_NAME}]\ntype = ${SERVICE_PROTOCOL}\nlocal_ip = ${SERVICE_IP_LOCAL}\nlocal_port = ${SERVICE_PORT_LOCAL}\nremote_port= ${SERVICE_PORT_REMOTE}\n ")
        fi
    done
fi

# Set a default config to process any ini files inside /frpc
cat << EOF > /frpc.ini
[common]
server_addr = ${FRPC_IP}
server_port = ${FRPC_PORT:-7000}
token = ${FRPC_TOKEN}
includes = /frpc/*.ini
${EXTRA_FRPC}
EOF

# Shell out our frpc
exec /usr/bin/frpc -c /frpc.ini