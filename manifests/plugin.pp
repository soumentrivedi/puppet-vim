define vim::plugin ($source = undef) {
  vcsrepo { "${vim::home_dir}/.vim/bundle/${name}":
    ensure   => present,
    provider => git,
    user     => $vim::user,
    source   => $source,
  }
}
