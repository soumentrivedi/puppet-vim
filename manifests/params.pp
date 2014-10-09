# Class: vim::params
#
# Params for vim
#
# Parameters:
#  - user:
#  - home_dir:
#  - vim_package:
#  - pathogen_source:
#  - plugin_source:

# Actions:
#
# Requires:
#
# Sample Usage:
#
class vim::params ($user = 'root', $home_dir = '/root',) {
  $vim_package = $operatingsystem ? {
    /CentOS|RedHat|OracleLinux/ => 'vim-enhanced',
    default                     => 'vim',
  }
  $pathogen_source = "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
  $plugin_source = {
    'puppet'    => {
      source      => "https://github.com/rodjek/vim-puppet.git",
    }
    ,
    'syntastic' => {
      source      => "https://github.com/scrooloose/syntastic.git",
    }
    ,
    'tabular'   => {
      source      => "https://github.com/godlygeek/tabular.git",
    }
    ,
  }
}
