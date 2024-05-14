{{- if (eq .Values.global.connectivity.network.mode "private") }}

# Modify /etc/hosts in order to route API server requests to the local API server replica.
# See more details here https://github.com/giantswarm/roadmap/issues/2223.

if [ "$1" == "preKubeadm" ]; then
	if [ ! -z "$(grep "^kubeadm init*" "/etc/kubeadm.sh")" ]; then
		echo '127.0.0.1   apiserver.{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }} apiserver' >> /etc/hosts;
	fi
fi


if [ "$1" == "postKubeadm" ]; then
	if [ ! -z "$(grep "^kubeadm join*" "/etc/kubeadm.sh")" ]; then
  		echo '127.0.0.1   apiserver.{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }}' >> /etc/hosts;
	fi
fi 

{{- else -}}
echo "There is no need to update /etc/hosts for public WCs."
exit 0

{{- end -}}

