from rest_framework import serializers

class IndustrySerializer(serializers.Serializer):
    industry_id = serializers.IntegerField()
    industry = serializers.CharField(max_length=70)
    