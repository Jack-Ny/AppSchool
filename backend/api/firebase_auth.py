import firebase_admin
from firebase_admin import credentials, auth
from rest_framework import authentication
from rest_framework import exceptions
from django.contrib.auth.models import User

cred = credentials.Certificate("firebase_config.json")
firebase_admin.initialize_app(cred)

class FirebaseAuthentication(authentication.BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.META.get("HTTP_AUTHORIZATION")
        if not auth_header:
            raise exceptions.AuthenticationFailed('No auth token provided')

        id_token = auth_header.split(" ").pop()
        try:
            decoded_token = auth.verify_id_token(id_token)
            uid = decoded_token["uid"]
            
            # Créer ou récupérer l'utilisateur
            try:
                user = User.objects.get(username=uid)
            except User.DoesNotExist:
                user = User.objects.create_user(
                    username=uid,
                    email=decoded_token.get("email", ""),
                )
                # Vous pouvez ajouter d'autres champs ici

            return (user, None)
        except Exception as e:
            raise exceptions.AuthenticationFailed(str(e))