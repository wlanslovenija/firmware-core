BEGIN {
  name_found = 0
}

{
  if ($1 == "Name:") {
    if ($2 == host) {
      name_found = 1
    }
    else {
      name_found = 0
    }
  }
  else if (name_found == 1) {
    if ($1 == "Address") {
      print $3, host
    }
    else if ($1 == "Address:") {
      print $2, host
    }
  }
}
