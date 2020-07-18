import { HttpClient, HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatInputModule} from '@angular/material/input';
import {MatIconModule} from '@angular/material/icon';
import {MatButtonModule} from '@angular/material/button';
import {MatSelectModule} from '@angular/material/select'; 
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './views/login/login.component';
import { OverviewComponent } from './views/overview/overview.component';
import { AnimalsComponent } from './views/animals/animals.component';
import { RangersComponent } from './views/rangers/rangers.component';
import { RangersToolbarComponent } from './views/rangers/rangers-toolbar/rangers-toolbar.component';
import { GeotagsComponent } from './views/geotags/geotags.component';
import { SettingsComponent } from './views/settings/settings.component';
import { SideNavigationComponent } from './components/side-navigation/side-navigation.component';
import { UtilityNavigationComponent } from './components/utility-navigation/utility-navigation.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
    RangersComponent,
	RangersToolbarComponent,
    GeotagsComponent,
    SettingsComponent,
    SideNavigationComponent,
    UtilityNavigationComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatFormFieldModule,
    MatInputModule,
    MatIconModule,
    MatButtonModule,
	MatSelectModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }