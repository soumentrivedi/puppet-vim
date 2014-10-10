# Class: vim
#
# This module manages vim & installs pathogen
#
# Parameters:
# $user
# $home_dir
# $vim_package
# $pathogen_source
# $plugin_source (hash of plugin name and source urls)
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
# class { 'vim':
#   user     => vagrant,
#   home_dir => /home/vagrant,
# }
#
class vim (
  $user            = $vim::params::user,
  $home_dir        = $vim::params::home_dir,
  $vim_package     = $vim::params::vim_package,
  $pathogen_source = $vim::params::pathogen_source,
  $plugin_source   = $vim::params::plugin_source) inherits vim::params {
  include wget

  package { 'vim':
    name   => $vim_package,
    ensure => installed
  }
  $pathogen_dir = [
    "${home_dir}/.vim",
    "${home_dir}/.vim/autoload",
    "${home_dir}/.vim/bundle",
    "/etc/skel/.vim",
    "/etc/skel/.vim/autoload",
    "/etc/skel/.vim/bundle"]

  file { $pathogen_dir:
    ensure => "directory",
    owner  => $user
  }

  wget::fetch { "DownloadPathogen_${user}":
    source             => $pathogen_source,
    destination        => "${home_dir}/.vim/autoload/pathogen.vim",
    verbose            => true,
    nocheckcertificate => true,
  }

  wget::fetch { "DownloadPathogen_skel":
    source             => $pathogen_source,
    destination        => "/etc/skel/.vim/autoload/pathogen.vim",
    verbose            => true,
    nocheckcertificate => true,
  }

  file { "${home_dir}/.vim/autoload/pathogen.vim": owner => $user }

  file { "/etc/skel/.vim/autoload/pathogen.vim": owner => "root" }

  $vimrc_content = "execute pathogen#infect()\nsyntax on\ncall pathogen#helptags()\nfiletype plugin indent on\nhighlight comment ctermfg=darkgray\n:set bg=dark"

  file { "${home_dir}/.vimrc":
    owner   => $user,
    content => $vimrc_content,
  }

  file { "/etc/skel/.vimrc":
    owner   => "root",
    content => $vimrc_content,
  }

  Package['vim'] -> File[
    "${home_dir}/.vim",
    "${home_dir}/.vim/autoload",
    "${home_dir}/.vim/bundle",
    "/etc/skel/.vim",
    "/etc/skel/.vim/autoload",
    "/etc/skel/.vim/bundle"] -> Wget::Fetch["DownloadPathogen_${user}", "DownloadPathogen_skel"] -> File[
    "${home_dir}/.vim/autoload/pathogen.vim",
    "/etc/skel/.vim/autoload/pathogen.vim"] -> File["${home_dir}/.vimrc", "/etc/skel/.vimrc"]

  create_resources("::vim::plugin", $plugin_source)
}
