#!/bin/bash

# Instellingen
PLAYBOOKS_DIR=/etc/ansible

# Controleren of het map pad bestaat
if [ ! -d "$PLAYBOOKS_DIR" ]; then
    echo "Fout: De opgegeven map voor playbooks bestaat niet."
    exit 1
fi

# Navigeer naar de map met playbooks
cd "$PLAYBOOKS_DIR" || exit 1

# Loop door alle playbooks en voer ze uit
for playbook in *.yml; do
    if [ -f "$playbook" ]; then
        echo "Uitvoeren van playbook: $playbook"
        ansible-playbook "$playbook"
        echo "------------------------------"
    fi
done

echo "Alle playbooks zijn uitgevoerd."
