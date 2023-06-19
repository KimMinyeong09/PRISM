"""prism_api URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from .views import *
urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/industry/', IndustryAPIView.as_view(), name='industry-api'),

    #아래는 https://www.notion.so/API-url-JSON-4dda3eaa812740a685547801e6d49f4a?pvs=4 참조
    path("rank/page/", oneOfPage),
    path("rank/oneCompany/years/", yearsOfCompany)
]
