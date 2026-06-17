# Load packages
library(tidyverse)

# Load processed data
spells <- read_csv("data/processed/spell_registry_clean.csv")

# Filter and rank spells by power and accuracy
top_spells <- spells %>%
  filter(danger_level != "Extreme") %>%  # exclude forbidden spells
  arrange(desc(power + accuracy)) %>%
  head(10)

# Save results
write_csv(top_spells, "resultaten/top_10_spells.csv")

# Plot: Power vs Accuracy
ggplot(spells, aes(x = accuracy, y = power, color = spell_type)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "Spell Power vs Accuracy",
       x = "Accuracy (%)",
       y = "Power") +
  ggsave("resultaten/spell_power_vs_accuracy.png", width = 8, height = 6)
