#$ kilmenow

exec { 'pkill':
  command  => 'pkill killmenow',
  provider => 'shell',
}
