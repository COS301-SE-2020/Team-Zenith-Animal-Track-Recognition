import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({ providedIn: 'root' })
export class MessageService {
	
	message: string;
	
	constructor(public snackBar: MatSnackBar){}

	show(message: string, dismissible: boolean) 
	{
		this.message = message;
		if (dismissible)
			this.snackBar.open(message, "Dismiss", { duration: 5000, });
		else if (!dismissible) 
			this.snackBar.open(message);
	}
	
	getMessage()
	{
		return this.message;
	}
	
	clear() 
	{
		this.message = "";
	}
}
