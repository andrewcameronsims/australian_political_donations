load: clean transform
	gsql etl/load.gsql
transform: clean
	ruby etl/transform.rb
clean:
	rm -f *.csv
