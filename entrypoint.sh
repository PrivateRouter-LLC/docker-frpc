#!/bin/ash

[[ -z "${FRPC_IP}" || -z "${FRPC_TOKEN}" ]] && {
    echo "FRPC_IP and FRPC_TOKEN must be set.";
    exit 1;
}

[[ "${CUSTOM_FRPC}" == "*[common]*" ]] && {
    echo "Your config cannot contain a [common] section.";
    exit 1;
}


[ -f /frpc/frpc.ini ] && CUSTOM_FRPC=$(cat /frpc/frpc.ini) || CUSTOM_FRPC=""

cat << EOF > /frpc.ini
[common]
server_addr = ${FRPC_IP}
server_port = 7000
token = ${FRPC_TOKEN}

${CUSTOM_FRPC}
EOF

exec /usr/bin/frpc -c /frpc.ini