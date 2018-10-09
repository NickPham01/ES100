'''
Define Dictionary with field pedaltype and read it in from csv 
'''

import csv

''' Read the file as tab delimited '''
with open("PedalDataGuitarCenterFenway20180921.txt", mode='r') as csv_file:
	csv_dict = csv.DictReader(csv_file, delimiter='\t')
	
	''' Process the data: '''
	for row in csv_dict:
		row.pop('')			# remove null key from dict

		# Outer_Dim = row.pop('Outer Dim')
		print row
		# print Outer_Dim


		# print row

