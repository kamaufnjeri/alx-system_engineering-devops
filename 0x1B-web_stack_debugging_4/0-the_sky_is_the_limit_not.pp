# 0-the_sky_is_the_limit_not.pp

# Install Nginx package (if not already installed)
package { 'nginx':
  ensure => 'installed',
}

# Define an Nginx site configuration
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => template('path/to/your/nginx_config.erb'),
}

# Create a symbolic link to enable the site
file { '/etc/nginx/sites-enabled/default':
  ensure  => link,
  target  => '/etc/nginx/sites-available/default',
  require => File['/etc/nginx/sites-available/default'],
}

# Reload Nginx to apply the changes
exec { 'reload-nginx':
  command     => '/usr/sbin/service nginx reload',
  refreshonly => true,
  subscribe   => File['/etc/nginx/sites-enabled/default'],
}

# Notify that the changes are completed
notify { 'Nginx configuration updated':
  require => Exec['reload-nginx'],
}
