import { Router } from '@angular/router';
import { Component, OnInit, Input } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';

@Component({
  selector: 'app-ranger-profile-card',
  templateUrl: './ranger-profile-card.component.html',
  styleUrls: ['./ranger-profile-card.component.css']
})
export class RangerProfileCardComponent implements OnInit {

  @Input() searchText: string;
  rangers;

  constructor(private http: HttpClient, private router: Router) {
  }

  ngOnInit(): void {
    this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{Users(TokenIn:"asdfg"){Token,Password,Access_Level,e_mail,firstName,lastName,phoneNumber}}')
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.printOut(temp);
      });
  }

  printOut(temp: any) {
    this.rangers = temp[0];
    this.sort(true);
  }

  sort(bool: boolean) {
    if (bool) {
      for (let i = 0; i < this.rangers.length - 1; i++) {
        for (let j = i + 1; j < this.rangers.length; j++) {
          if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
            let temp = this.rangers[i];
            this.rangers[i] = this.rangers[j];
            this.rangers[j] = temp;
          }
        }
      }
    } else {
      for (let i = 0; i < this.rangers.length - 1; i++) {
        for (let j = i + 1; j < this.rangers.length; j++) {
          if (this.rangers[i].Access_Level > this.rangers[j].Access_Level) {
            let temp = this.rangers[i];
            this.rangers[i] = this.rangers[j];
            this.rangers[j] = temp;
          }
        }
      }
    }
  }
}
