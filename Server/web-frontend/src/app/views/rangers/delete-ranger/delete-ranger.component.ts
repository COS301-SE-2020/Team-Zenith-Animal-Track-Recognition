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

  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private router: Router) { }

  ngOnInit(): void {
  }

  confirmDelete() {
    let temp = this.http.post<any>('http://putch.dyndns.org:55555/graphql?query=mutation{DeleteUser('
      + 'TokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
      + 'TokenDelete:"' + this.data.Token + '"){Token}}', '').subscribe((dt: any[]) => {
        let t = [];
        t = Object.values(Object.values(dt)[0]);
      });

    this.router.navigate(["/geotags"], { queryParams: { reload: "true" } });
  }
}
