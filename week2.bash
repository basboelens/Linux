#!/bin/bash

# Controleer of het juiste aantal parameters is meegegeven
if [ "$#" -ne 2 ]; then
  echo "Gebruik: $0 <foto_directory> <maand/week>"
  exit 1
fi

# Pak de parameters in variabelen
foto_directory="$1"
tijdseenheid="$2"

# Controleer of de opgegeven directory bestaat
if [ ! -d "$foto_directory" ]; then
  echo "Ongeldige directory: $foto_directory"
  exit 1
fi

# Functie om de hash van een bestand te berekenen (MD5)
calculate_hash() {
  md5sum "$1" | awk '{ print $1 }'
}

# Functie om foto's te verplaatsen en controleren op succesvolle kopie
move_and_verify() {
  source_file="$1"
  destination_directory="$2"

  # Verplaats de foto naar de opgegeven directory
  mv "$source_file" "$destination_directory/"

  # Controleer of de verplaatsing succesvol was
  if [ $? -eq 0 ]; then
    echo "Verplaatst: $source_file naar $destination_directory"

    # Controleer de hash van het origineel en de kopie
    original_hash=$(calculate_hash "$source_file")
    copied_hash=$(calculate_hash "$destination_directory/$(basename "$source_file")")

    # Als de hashes overeenkomen, verwijder het origineel
    if [ "$original_hash" == "$copied_hash" ]; then
      rm "$source_file"
      echo "Verwijderd: $source_file"
    else
      echo "Waarschuwing: Hashes komen niet overeen, origineel niet verwijderd."
    fi
  else
    echo "Fout bij het verplaatsen van: $source_file"
  fi
}

# Maak een nieuwe folder op basis van maand of week
if [ "$tijdseenheid" == "maand" ]; then
  destination_folder=$(date +"%Y-%m")
elif [ "$tijdseenheid" == "week" ]; then
  destination_folder=$(date +"%Y-%U")
else
  echo "Ongeldige tijdseenheid: $tijdseenheid (gebruik 'maand' of 'week')"
  exit 1
fi

# Controleer of de bestemmingsfolder bestaat, anders maak deze aan
destination_directory="$foto_directory/$destination_folder"
if [ ! -d "$destination_directory" ]; then
  mkdir -p "$destination_directory"
fi

# Loop door de foto's in de opgegeven directory
for photo in "$foto_directory"/*; do
  if [ -f "$photo" ]; then
    move_and_verify "$photo" "$destination_directory"
  fi
done

exit 0
