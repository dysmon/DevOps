from django.shortcuts import render
from datetime import date
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
# Create your views here.
@api_view(['GET'])
def how_many_days_left(request):
    today = date.today()
    new_year = date(today.year + 1, 1 , 1)
    days_remaining = (new_year - today).days

    return Response({"Дней до 2025 осталось ": days_remaining}, status=status.HTTP_200_OK)