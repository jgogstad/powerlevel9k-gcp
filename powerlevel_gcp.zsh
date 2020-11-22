function gcloud_config_value {
  # gcloud cli is too slow, access file directly
  local active=$(<~/.config/gcloud/active_config)
  local config="$HOME/.config/gcloud/configurations/config_$active"
  sed -nE "/$1/ s/.*$1 = ([^ ]+).*/\1/p" < $config
}

function prompt_gcp_user {
  if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
    local username=$(sed -nE '/email/ s/.*email": "([^"]+)".*/\1/p' < "$GOOGLE_APPLICATION_CREDENTIALS")
    if [[ -z $username ]]; then
      username="invalid"
    fi
  else
    local username=$(gcloud_config_value account)
  fi

  local icon

  if [[ $username == *"iam.gserviceaccount.com" ]]; then
    icon="%F{red}"
  else
    icon="%F{027}"
  fi

  p10k segment -b white -f black -t "${username%.iam.gserviceaccount.com*}" -i "${icon}" +r
}
