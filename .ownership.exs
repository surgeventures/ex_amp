package_managers = [
  # leads
  "ksluszniak@gmail.com",
  "kowalski.tychy@gmail.com",

  # teams
  "maciej.m@shedul.com", # spirit
  "maciej@shedul.com", # zen
  "marcin.s@shedul.com", # janusze
  "pawel@shedul.com" # undefined
]

packages = ~w[
  blalblaslda
  confix
  jabbax
  modular
  parseus
  plug_devise_session
  protein
  repo_example
  sea
  surgex
]a

for manager <- package_managers, package <- packages, do: {package, manager}
