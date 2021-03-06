apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/node_validator 
  values:
    replicaCount: 1

    healthcheck:
      readinessthreshold: 100
      readinesscheckinterval: 5

    staticnodes:
{% for enode in enode_data_list %}
      - "enode://{{ enode.enodeval }}@{{ enode.peer_publicIP }}:{{ enode.p2p_ambassador }}"
{% endfor %}

    metadata:
      namespace: {{ component_ns }}
      labels:

    ambassador:
      external_url_suffix: {{ external_url }}

    liveliness_check:
      enabled: false

    proxy:
      provider: ambassador
      external_url: {{ name }}.{{ external_url }}
      p2p: {{ peer.p2p.ambassador }}
      rpc: {{ peer.rpc.ambassador }}
      ws: {{ peer.ws.ambassador }}

    images:
      node: hyperledger/besu:{{ network.version }}
      alpineutils: hyperledgerlabs/alpine-utils:1.0

    node:
      name: {{ peer.name }}
      consensus: {{ consensus }}
      mountPath: /etc/genesis
      servicetype: ClusterIP
      imagePullSecret: regcred
      ports:
        p2p: {{ peer.p2p.port }}
        rpc: {{ peer.rpc.port }}
        ws: {{ peer.ws.port }}

    storage:
      storageclassname: {{ storageclass_name }}
      storagesize: 1Gi

    vault:
      address: {{ vault.url }}
      secretprefix: secret/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: data
      role: vault-role
      authpath: besu{{ name }}

    genesis: {{ genesis }}
