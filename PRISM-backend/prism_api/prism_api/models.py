# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

class dummy(models.Model):
    pass

class Company(models.Model):
    company_id = models.AutoField(primary_key=True)
    company = models.CharField(max_length=90, blank=True, null=True)
    industry = models.ForeignKey('Industry', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'COMPANY'


class EsglabIndAvgScore(models.Model):
    esglab_ind_avg_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    overall_score = models.CharField(max_length=2)
    e_score = models.CharField(max_length=2, blank=True, null=True)
    s_score = models.CharField(max_length=2, blank=True, null=True)
    g_score = models.CharField(max_length=2, blank=True, null=True)
    industry = models.ForeignKey('Industry', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'ESGLAB_IND_AVG_SCORE'


class EsglabScore(models.Model):
    esglab_score_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    overall_score = models.CharField(max_length=2)
    e_score = models.CharField(max_length=2, blank=True, null=True)
    s_score = models.CharField(max_length=2, blank=True, null=True)
    g_score = models.CharField(max_length=2, blank=True, null=True)
    company = models.ForeignKey(Company, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'ESGLAB_SCORE'


class GriIndex(models.Model):
    gri_index_id = models.AutoField(primary_key=True)
    major_num = models.CharField(max_length=3)
    major_name = models.CharField(max_length=70)
    middle_num = models.CharField(max_length=3)
    middle_name = models.CharField(max_length=70)
    sub_num = models.CharField(max_length=6)
    sub_name = models.CharField(max_length=70)

    class Meta:
        managed = False
        db_table = 'GRI_INDEX'


class GriUsageIndAvgScore(models.Model):
    gri_usage_ind_avg_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    e_score = models.IntegerField()
    s_score = models.IntegerField()
    g_score = models.IntegerField()
    industry = models.ForeignKey('Industry', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'GRI_USAGE_IND_AVG_SCORE'


class Industry(models.Model):
    industry_id = models.AutoField(primary_key=True)
    industry = models.CharField(max_length=70)

    class Meta:
        managed = False
        db_table = 'INDUSTRY'


class IndWeight(models.Model):
    ind_weight_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    weight = models.FloatField()
    industry = models.ForeignKey(Industry, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'IND_WEIGHT'


class KcgsIndAvgScore(models.Model):
    kcgs_ind_avg_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    overall_score = models.CharField(max_length=2)
    e_score = models.CharField(max_length=2)
    s_score = models.CharField(max_length=2)
    g_score = models.CharField(max_length=2)
    industry = models.ForeignKey(Industry, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'KCGS_IND_AVG_SCORE'


class KcgsScore(models.Model):
    kcgs_score_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    overall_score = models.CharField(max_length=2)
    e_score = models.CharField(max_length=2)
    s_score = models.CharField(max_length=2)
    g_score = models.CharField(max_length=2)
    company = models.ForeignKey(Company, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'KCGS_SCORE'


class PrismIndAvgScore(models.Model):
    prism_ind_avg_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    overall_score = models.IntegerField()
    e_score = models.IntegerField()
    s_score = models.IntegerField()
    g_score = models.IntegerField()
    w_overall_score = models.IntegerField()
    w_e_score = models.IntegerField()
    w_s_score = models.IntegerField()
    w_g_score = models.IntegerField()
    industry = models.ForeignKey(Industry, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'PRISM_IND_AVG_SCORE'


class PrismScore(models.Model):
    prism_score_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    overall_score = models.IntegerField()
    e_score = models.IntegerField()
    s_score = models.IntegerField()
    g_score = models.IntegerField()
    w_overall_score = models.IntegerField()
    w_e_score = models.IntegerField()
    w_s_score = models.IntegerField()
    w_g_score = models.IntegerField()
    company_id = models.ForeignKey(Company, on_delete=models.DO_NOTHING, db_column="company_id")

    class Meta:
        managed = False
        db_table = 'PRISM_SCORE'


class ReportSentences(models.Model):
    report_senetences_id = models.AutoField(primary_key=True)
    sim_rank = models.IntegerField()
    most_sentences = models.TextField()
    preced_sentences = models.TextField(blank=True, null=True)
    back_sentences = models.TextField(blank=True, null=True)
    page_num = models.IntegerField()
    gri_index = models.ForeignKey(GriIndex, models.DO_NOTHING)
    sustain_report = models.ForeignKey('SustainReport', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'REPORT_SENTENCES'


class ReportTable(models.Model):
    report_table_id = models.AutoField(primary_key=True)
    sim_rank = models.IntegerField()
    title = models.CharField(max_length=1000)
    html_code = models.TextField(blank=True, null=True)
    page_num = models.IntegerField()
    gri_index = models.ForeignKey(GriIndex, models.DO_NOTHING)
    sustain_report = models.ForeignKey('SustainReport', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'REPORT_TABLE'


class SustainReport(models.Model):
    sustain_report_id = models.AutoField(primary_key=True)
    eval_year = models.IntegerField()
    download_link = models.TextField()
    e_score = models.IntegerField()
    s_score = models.IntegerField()
    g_score = models.IntegerField()
    company = models.ForeignKey(Company, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'SUSTAIN_REPORT'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'
