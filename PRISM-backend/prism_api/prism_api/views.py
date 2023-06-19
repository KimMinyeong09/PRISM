from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .serializers import *
from django.db import connection
import pprint

#프린트디버깅용
def dp(sql_result):
    print("###########디버깅시작")
    pprint.pprint(sql_result)
    print("#####디버깅종료")

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

@api_view(["POST"])
def page(request):
    pass

@api_view(["POST"])
def yearsOfCompany(request):
    imported_data = request.data
    with connection.cursor() as cursor:
        try:
            company_name = imported_data["company"]
            sql = f"SELECT company_id FROM COMPANY WHERE company='{company_name}'"
            cursor.execute(sql)
            data = cursor.fetchone()
            company_id = data[0]
            sql = f"SELECT eval_year FROM PRISM_SCORE WHERE company_id={company_id}"
            cursor.execute(sql)
            data = cursor.fetchall()
            
            serializer_data = [{
                "years":[int(row[0]) for row in data]
            }]
            dp(serializer_data)
            serializer = yearsOfCompanySerializer(data=serializer_data, many = True)
            if serializer.is_valid() is False:
                raise ValueError("invalid serializer")
            dp(serializer.data)
            return Response(serializer.data)
        except:
            return Response("data not found", status=status.HTTP_404_NOT_FOUND)
