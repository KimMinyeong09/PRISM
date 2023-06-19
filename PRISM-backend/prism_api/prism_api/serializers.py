from rest_framework import serializers

class IndustrySerializer(serializers.Serializer):
    industry_id = serializers.IntegerField()
    industry = serializers.CharField(max_length=70)
    
class onePageSerializer(serializers.Serializer):
    page = serializers.IntegerField()
    filter_score = serializers.CharField()
    filter_industries = serializers.CharField()

class yearsOfCompanySerializer(serializers.Serializer):
    years = serializers.ListField(child = serializers.IntegerField())

class oneOfPageSerializer(serializers.Serializer):
    name = serializers.CharField()
    industry = serializers.CharField()
    score = serializers.IntegerField()
    esg_insts = serializers.ListField(child = serializers.CharField())
    pages_number = serializers.IntegerField()