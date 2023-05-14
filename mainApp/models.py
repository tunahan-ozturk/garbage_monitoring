from django.db import models

#Create your models here.
class garbageLog(models.Model):
    eventID = models.AutoField(primary_key=True)
    creationDate = models.DateField(auto_now_add = True)
    ratio = models.FloatField()

    class Meta:
        db_table = 'garbageLog'

    def __str__(self) -> str:
        return f"{self.eventID} | ({self.creationDate}) {self.ratio}"