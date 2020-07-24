import { first } from 'rxjs/operators';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-delete-ranger',
  templateUrl: './delete-ranger.component.html',
  styleUrls: ['./delete-ranger.component.css']
})
export class DeleteRangerComponent implements OnInit {

  temp: boolean;

  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private router: Router) { }

  ngOnInit(): void {
    this.temp = false;
  }

  confirmDelete(test: boolean) {
    if (test) {
      return true;
    }

    console.log(JSON.parse(localStorage.getItem('currentToken'))['value']);
    console.log(this.data.Token);
    let temp = this.http.post<any>('http://putch.dyndns.org:55555/graphql?query=mutation{DeleteUser('
      + 'TokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
      + 'TokenDelete:"' + this.data.Token + '"){msg}}', '').subscribe((dt: any[]) => {
        let t = [];
        t = Object.values(Object.values(dt)[0]);
      });

    this.router.navigate(["/geotags"], { queryParams: { reload: "true" } });
    return false;
  }
}
