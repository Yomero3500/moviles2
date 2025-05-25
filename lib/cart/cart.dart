import	'../models/product.dart';	
class	Cart	{	
		static	final	List<Map>	_items	=	[];	
	
		static	void	add(Map	product)	=>	_items.add(product);	
		static	void	remove(Map	product)	=>	_items.remove(product);	
		static	List<Map>	get	items	=>	_items;	
		static	double	get	total	=>	_items.fold(0,	(sum,	item)	=>	sum	+	(item['price']	??	0));	
}