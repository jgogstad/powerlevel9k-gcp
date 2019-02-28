function gcloud_config_value {
  # gcloud cli is too slow, access file directly
  local active=$(<~/.config/gcloud/active_config)
  local config="$HOME/.config/gcloud/configurations/config_$active"
  sed -nE "/$1/ s/.*$1 = ([^ ]+).*/\1/p" < $config
}

function prompt_gcp_project {
  local project=$(gcloud_config_value project)
  $1_prompt_segment "$0" "$2" white black "$project" "GCP_PROJECT_ICON"
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
    icon=GCP_SERVICE_ACCOUNT_ICON
  else
    icon=GCP_USER_ICON
  fi

  $1_prompt_segment "$0" "$2" white black "${username%.iam.gserviceaccount.com*}" "$icon"
}

## GCP config
POWERLEVEL9K_GCP_PROJECT_ICON="%F{202}\ue7b2"
POWERLEVEL9K_GCP_USER_ICON="%F{027}\uf415"
POWERLEVEL9K_GCP_SERVICE_ACCOUNT_ICON="%F{red}\uf013"