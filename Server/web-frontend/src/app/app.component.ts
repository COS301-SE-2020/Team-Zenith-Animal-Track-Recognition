import { Component } from '@angular/core';

const ROOT_QUERY_STRING = "http://ec2-13-244-203-16.af-south-1.compute.amazonaws.com:55555/graphql";

export { ROOT_QUERY_STRING }

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'web-frontend';
}
