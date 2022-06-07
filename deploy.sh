#!/usr/bin/env bash
helm dependency build guestbook
helm dependency update
helm upgrade guestbook  ./guestbook --install --values=guestbook/values.yaml