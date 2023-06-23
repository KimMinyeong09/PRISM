from rest_framework import serializers
from .models import *
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

class PrismScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = PrismScore
        fields = "__all__"

class OneCompanyPrismScoreSerializer(serializers.Serializer):
    overall_rank = serializers.IntegerField()
    e_rank = serializers.IntegerField()
    s_rank = serializers.IntegerField()
    g_rank = serializers.IntegerField()
    ind_overall_rank = serializers.IntegerField()
    ind_e_rank = serializers.IntegerField()
    ind_s_rank = serializers.IntegerField()
    ind_g_rank = serializers.IntegerField()
    w_overall_rank = serializers.IntegerField()
    w_e_rank = serializers.IntegerField()
    w_s_rank = serializers.IntegerField()
    w_g_rank = serializers.IntegerField()
    eval_year = serializers.IntegerField()
    overall_score = serializers.IntegerField()
    e_score = serializers.IntegerField()
    s_score = serializers.IntegerField()
    g_score = serializers.IntegerField()
    w_overall_score = serializers.IntegerField()
    w_e_score = serializers.IntegerField()
    w_s_score = serializers.IntegerField()
    w_g_score = serializers.IntegerField()

class PrismIndAvgScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = PrismIndAvgScore
        fields = "__all__"

class KcgsScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = KcgsScore
        fields = "__all__"
class EsglabScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = EsglabScore
        fields = "__all__"
class KcgsIndAvgScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = KcgsIndAvgScore
        fields = "__all__"
class EsglabIndAvgScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = EsglabIndAvgScore
        fields = "__all__"
class SustainReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = SustainReport
        fields = "__all__"
class OneCompanyReportSentencesSerializer(serializers.Serializer):
    sim_rank = serializers.IntegerField()
    most_sentences = serializers.CharField()
    preced_sentences = serializers.CharField()
    back_sentences = serializers.CharField()
    page_num = serializers.IntegerField()
    gri_index = serializers.CharField()
class TestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Company
        fields = "__all__"