import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { NgOptimizedImage } from '@angular/common'

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { LibraryComponent } from './pages/library/library.component';
import { TreeComponent } from './pages/tree/tree.component';
import { NodeComponent } from './pages/node/node.component';

@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    NgOptimizedImage,
    ProfileComponent,
    LibraryComponent,
    TreeComponent,
    NodeComponent
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
