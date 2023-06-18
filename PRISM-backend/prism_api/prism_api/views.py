from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import IndustrySerializer
from django.db import connection

class IndustryAPIView(APIView):
    def get(self, request):
        with connection.cursor() as cursor:
            sql = "SELECT * FROM INDUSTRY"
            cursor.execute(sql)
            data = cursor.fetchall()

        serializer_data = [
            {
                'industry_id': row[0],
                # 다른 필드들에 대해서도 필요한 대로 매핑
                'industry': row[1]
            }
            for row in data
        ]

        serializer = IndustrySerializer(serializer_data, many=True)
        return Response(serializer.data)