BEGIN {
  in_client = 0
  client_num = 0
}

{
  n = split($1, a, /=/)

  if (n == 1) {
    client_count = a[1]
  } else if (n == 2) {
    field = a[1]
    value = a[2]

    if (field == "client_id") {
      in_client = 1
    } else if (field == "ip") {
      fields[field] = value
    } else if (field == "mac") {
      # MAC address is supressed
    } else if (field == "added") {
      fields["added_at"] = value
    } else if (field == "duration") {
      fields["active_duration"] = value
    } else if (field == "downloaded") {
      fields["down"] = value
    } else if (field == "uploaded") {
      fields["up"] = value
    } else if (field == "avg_down_speed") {
      fields["avg_down"] = value
    } else if (field == "avg_up_speed") {
      fields["avg_up"] = value
    }
  } else if (n == 0 && in_client == 1) {
    in_client = 0

    for (field in fields) {
      printf("nds.client%d.%s: %s\n", client_num, field, fields[field])
    }
    
    client_num = client_num + 1
  }
}
