# Optimize Nginx Configuration

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}

# Define Nginx configuration file
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('nginx/nginx.conf.erb'), # Use an ERB template
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Define the Nginx server block configuration
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('nginx/default.erb'), # Use an ERB template
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Ensure the default site is enabled
file { '/etc/nginx/sites-enabled/default':
  ensure  => link,
  target  => '/etc/nginx/sites-available/default',
  require => File['/etc/nginx/sites-available/default'],
  notify  => Service['nginx'],
}

# Create a custom Nginx config file to adjust connection and buffer settings
file { '/etc/nginx/conf.d/custom.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('nginx/custom.conf.erb'), # Use an ERB template
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Reload Nginx when the main configuration changes
exec { 'reload-nginx':
  command     => 'nginx -t && systemctl reload nginx',
  path        => '/usr/bin',
  refreshonly => true,
  subscribe   => [
    File['/etc/nginx/nginx.conf'],
    File['/etc/nginx/sites-available/default'],
    File['/etc/nginx/conf.d/custom.conf'],
  ],
  require     => Package['nginx'],
}

# Define custom ERB templates for Nginx configurations
file { '/etc/nginx/nginx.conf':
  content => template('nginx/nginx.conf.erb'),
}

file { '/etc/nginx/sites-available/default':
  content => template('nginx/default.erb'),
}

file { '/etc/nginx/conf.d/custom.conf':
  content => template('nginx/custom.conf.erb'),
}
