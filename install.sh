#!/bin/bash

# Verificar se o brew está instalado
if ! command -v brew &>/dev/null; then
  echo "Homebrew não está instalado. Instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#brew install git



# Atualizar e preparar o brew
brew update
brew upgrade

# Detectar versão do macOS
macos_version=$(sw_vers -productVersion)
echo "Detectado macOS versão $macos_version"

# Função para instalar pacotes
install_package() {
  local package=$1
  if ! brew list --formula | grep -q "^$package$"; then
    echo "Instalando $package..."
    brew install $package
  else
    echo "$package já está instalado."
  fi
}

# Função para instalar aplicativos cask (GUI)
install_cask() {
  local app=$1
  if ! brew list --cask | grep -q "^$app$"; then
    echo "Instalando $app..."
    brew install --cask $app
  else
    echo "$app já está instalado."
  fi
}

# Linguagens de programação
languages=(
  "gcc"
  "openjdk"
  "go"
  "lua"
  "php"
  "node"
  "python"
  "ruby"
  "rust"
)

# Aplicativos úteis para desenvolvimento
apps=(
  "gedit"
  "visual-studio-code"
  "intellij-idea-ce"
  "docker"
)

# Instalar linguagens de programação
for lang in "${languages[@]}"; do
  install_package "$lang"
done

# Instalar aplicativos
for app in "${apps[@]}"; do
  install_cask "$app"
done

# Instalar outras bibliotecas e ferramentas opcionais
read -p "Deseja instalar outras ferramentas (como MySQL, PostgreSQL, etc.)? (s/n): " opt
if [[ "$opt" =~ ^[Ss]$ ]]; then
  additional_tools=(
    "mysql"
    "postgresql"
    "redis"
    "mongodb"
    "nginx"
    "httpd" # Apache
  )

  for tool in "${additional_tools[@]}"; do
    install_package "$tool"
  done
fi

# Instalar suporte adicional para linguagens
read -p "Deseja instalar bibliotecas adicionais para linguagens (como pip, npm, etc.)? (s/n): " opt
if [[ "$opt" =~ ^[Ss]$ ]]; then
  echo "Instalando bibliotecas adicionais..."
  # Python
  if command -v python3 &>/dev/null; then
    python3 -m ensurepip
    python3 -m pip install --upgrade pip setuptools
  fi

  # Node.js
  if command -v npm &>/dev/null; then
    npm install -g npm@latest
  fi

  # Ruby
  if command -v gem &>/dev/null; then
    gem update --system
  fi

  # PHP Composer
  if ! command -v composer &>/dev/null; then
    install_package composer
  fi

  # Rust Cargo
  if command -v rustup &>/dev/null; then
    rustup update
  fi
fi

# Finalização
echo "\nInstalação completa! Ferramentas de desenvolvimento estão prontas."
