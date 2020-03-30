#!/bin/bash
#
# Database setup
#

is_rhel8() {
    ([[ -f /etc/os-release ]] && source /etc/os-release && [[ "$ID_LIKE" == *rhel* && "$VERSION_ID" == 8* ]])
}

init_local_postgres() {
    SERVICE_NAME=postgresql

    if [[ "$(systemctl -q show $SERVICE_NAME --property=LoadState)" != "LoadState=loaded" ]]; then
      return 0
    fi
    # check if postgres is already running
    systemctl -q is-active $SERVICE_NAME && return 0

    # Copied from postgresql-setup. Determine default data directory
    PGDATA=$(systemctl -q show -p Environment "${SERVICE_NAME}.service" | sed 's/^Environment=//' | tr ' ' '\n' | sed -n 's/^PGDATA=//p' | tail -n 1)
    if [ -z "$PGDATA" ]; then
        echo "failed to find PGDATA setting in ${SERVICE_NAME}.service"
        return 1
    fi

    if [ ! -e "$PGDATA/PG_VERSION" ]; then
        if is_rhel8; then
            cmd="--initdb"
        else
            cmd="initdb"
        fi
        PGSETUP_INITDB_OPTIONS="--auth-host=md5 -E UTF8" postgresql-setup $cmd || return 1
    fi

    # ensure that PostgreSQL is running
    systemctl start $SERVICE_NAME || return 1
}

init_local_postgres
