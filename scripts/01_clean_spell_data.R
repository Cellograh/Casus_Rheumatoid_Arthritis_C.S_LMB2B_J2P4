# Load required packages
library(tidyverse)

# Load raw data
spell_data <- read_csv("data/raw/spell_registry.csv")
wand_data <- read_csv("data/raw/wand_compatibility.csv")

# Clean spell names
spell_data_clean <- spell_data %>%
  mutate(spell_name = str_trim(spell_name))

# Save cleaned data
write_csv(spell_data_clean, "data/processed/spell_registry_clean.csv")
