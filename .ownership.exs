package_managers = ~w[
  ksluszniak@gmail.com
  pawel@shedul.com
  maciej.m@shedul.com
]

packages = ~w[
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
